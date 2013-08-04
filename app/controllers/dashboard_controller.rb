class DashboardController < ApplicationController
  def index
    # member = Trello::Member.find("daisukeyamashita2")
    board = Rails.cache.fetch('trello_board', expires_in: 1.day) do
      Trello::Board.find(BoardStatus::BoardId)
    end
    @lists = Rails.cache.fetch('trello_lists', expires_in: 1.day) do
      board.lists
    end
    proposed_list = Rails.cache.fetch("trello_lists_#{ListStatus::PROPOSED}", expires_in: 1.day) do
      Trello::List.find(ListStatus::PROPOSED)
    end
    @proposed = checklists(proposed_list)

    planned_list = Rails.cache.fetch("trello_lists_#{ListStatus::PLANNED}", expires_in: 1.day) do
      Trello::List.find(ListStatus::PLANNED)
    end
    @planned = checklists(planned_list)

    in_progress_list = Rails.cache.fetch("trello_lists_#{ListStatus::IN_PROGRESS}", expires_in: 1.day) do
      Trello::List.find(ListStatus::IN_PROGRESS)
    end
    @in_progress = checklists(in_progress_list)

    launched_list = Rails.cache.fetch("trello_lists_#{ListStatus::LAUNCHED}", expires_in: 1.day) do
      Trello::List.find(ListStatus::LAUNCHED)
    end
    @launched = checklists(launched_list)
  end

  private

  def fetch_cards(list)
    Rails.cache.fetch("trello_cards_#{list.id}", expires_in: 1.day) do
      list.cards
    end
  end

  def fetch_checklists(card)
    Rails.cache.fetch("trello_checklists_#{card.id}", expires_in: 1.day) do
      card.checklists
    end
  end

  def fetch_items(checklist)
    Rails.cache.fetch("trello_items_#{checklist.id}", expires_in: 1.day) do
      checklist.items
    end
  end

  def card_names(list)
    cards = fetch_cards(list)
    cards.maps {|card| card.name }
  end

  def fetch_check_item_state(checklist)
    Rails.cache.fetch("trello_check_items_#{checklist.id}", expires_in: 1.day) do
      checklist.check_items
    end
  end

  def checklists(list)
    checklist_result = []
    cards = fetch_cards(list)
    cards.each do |card|
      checklist_datas = []
      checklists = fetch_checklists(card)
      checklists.each do |checklist|
        checklist_data = {}
        item_names = {}
        items = fetch_items(checklist)
        items.each do |item|
          name = item.name
          if name =~ /^o/
            item_names[item.id] = { name: name.slice(1, name.size) }
          end
        end
        complete_count = 0
        incomplete_count = 0
        item_complete = false
        check_items = fetch_check_item_state(checklist)
        check_items.each do |check_item|
          case check_item['state']
          when CheckItemStatus::COMPLETE
            complete_count += 1
            item_name = item_names[check_item['id']]
            item_name[:status] = true if item_name
          when CheckItemStatus::INCOMPLETE
            incomplete_count += 1
            item_name = item_names[check_item['id']]
            item_name[:status] = false if item_name
          end
        end
        item_names = item_names.map do |item_name|
          item = item_name.second
          name = item[:name]
          status = item[:status]
          { name: name, status: status }
        end
        progress_rate = 0
        progress_rate = (complete_count.to_f / items.count * 100).round if complete_count != 0
        checklist_data[:checklist_name] = checklist.name
        checklist_data[:progress_rate] = progress_rate
        checklist_data[:item_names] = item_names
        checklist_datas << checklist_data
      end
      checklist_result << { card_name: card.name, checklists: checklist_datas }
    end
    checklist_result
  end
end
