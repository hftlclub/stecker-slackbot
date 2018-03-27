module.exports = (robot) ->
  cronJob = require('cron').CronJob
  tz = 'Germany/Berlin'
  new cronJob('0 */1 * * * *', everyMinute, null, true, tz)

  room = '#testtoignore' #roomname

  everyMinute = ->
    robot.messageRoom room, 'I will nag you every minute'
