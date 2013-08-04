trello-development-dashboard
============================

Display ship planning to customer. Tasks management on a trello.

### Build a development plan dashboard from this trello dashboard.
![2013-08-05 6 28 00](https://f.cloud.github.com/assets/96539/907622/cb4ce118-fd4d-11e2-8f87-c407329065f4.png)
![2013-08-05 6 39 59](https://f.cloud.github.com/assets/96539/907628/71ccd160-fd4e-11e2-8303-434cd32b9d79.png)

### How to display or hide?
The card will be exhibited if 'o' is inserted in the prefix of a card title. This is able to use on the checklists & tasks.

![2013-08-05 6 28 53](https://f.cloud.github.com/assets/96539/907619/c1f7f72e-fd4d-11e2-97a4-e1ab45e0e224.png)
![2013-08-05 6 38 43](https://f.cloud.github.com/assets/96539/907626/496af544-fd4e-11e2-93f8-60154a02c528.png)

![2013-08-05 6 28 20](https://f.cloud.github.com/assets/96539/907621/c8634172-fd4d-11e2-9834-5d281156f514.png)
![2013-08-05 6 39 19](https://f.cloud.github.com/assets/96539/907627/5d52d860-fd4e-11e2-8c7b-5f724c37b683.png)

# How to use on the heroku?

### You get developer key & setting ENV variable

Please check your developer key [from here](https://trello.com/1/appKey/generate).

And get a token without a expiration from following url. 
> https://trello.com/1/authorize?key=substitutewithyourapplicationkey&name=My+Application&expiration=never&response_type=token


> heroku config:add TRELLO_DEVELOPER_PUBLIC_KEY=your-key
> 
> heroku config:add TRELLO_MEMBER_TOKEN=your-token


> https://trello.com/1/members/my/boards?key=your-key&token=your-token


> heroku config:add TRELLO_BOARD_ID=target-board-id


> https://trello.com/1/boards/your-target-board-id/lists?key=your-key&token=your-token


> heroku config:add TRELLO_PROPOSED_LIST_ID=target-list-id
> 
> heroku config:add TRELLO_PLANNED_LIST_ID=target-list-id
> 
> heroku config:add TRELLO_PROGRESS_LIST_ID=target-list-id
> 
> heroku config:add TRELLO_LAUNCHED_LIST_ID=target-list-id

### Setting the user account for the BASIC Authentication

You can purge the cache from 'http://your-app.herokuapp.com/cache/clear'. But this page blocked by BASIC authentication. 
Therefore you should setting your account for BASIC authentication.

> heroku config:add TDD_NAME=your-name
> 
> heroku config:add TDD_PASS=your-password
