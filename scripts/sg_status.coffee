# Description:
#   Email from hubot to all_support
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot status <message> - Sends email with the <subject> <message> to defined address
#
# Author:
#   jacobmovingfwd
#
# Additional Requirements
#   SendGrid account

util = require 'util'
http = require 'http'
nodemailer = require 'nodemailer'

# create reusable transport method (opens pool of SMTP connections)
sgTransport = nodemailer.createTransport("SMTP",
  service: "SendGrid"
  auth:
    user: "wikibot"
    pass: "UUY64uFX4n(^VM@Gssjn"
)

bkTransport = nodemailer.createTransport("SMTP",
  service: "Hotmail"
  auth:
    user: "jacobleesg@hotmail.com",
    pass: "03jAc*b84"
)

module.exports = (robot) ->
  emailTime = null
  robot.respond /status (.*)/i, (msg) ->
    text = msg.match[1]
    from = msg.message.user.name
    mailOptions =
      from: "#{from} <alert@sendgrid.com>" # sender address
      to: "411-inbound@sendgrid.com" # list of recipients
      subject: "New Alert in 411 Room" # Subject line
      generateTextFromHTML: true
      html: "<p><b>This email has been generated to notify you that Support has issued a customer facing post and tweet. <br>For more detailed Support or Operational communications please follow this issue in the 411 HipChat room where we can provide updates.<br>Here’s the 411:</p></b></p><p>#{text}</p><p><i>Please keep the 411 HipChat room open for future updates.</i></p>" # html body

    sgTransport.sendMail mailOptions, (error, response) ->
      if error
        console.log error
        msg.send "SG Error: " + error.data
        sgTransport.close()

        bkTransport.sendMail mailOptions, (error, response) ->
          if error
            bkTransport.close()
            console.log error
            msg.send "Backup error: " + error.data 
            msg.send "Do you want me to sit in a corner and rust or just fall apart where I'm standing? (foreveralone)"
          else
            console.log "Message sent on Backup: " + response.message
            msg.send "Message sent on Backup: " + response.message
      else
        msg.send "@all Status: " + text
        console.log "Message sent: " + text + response.message
        msg.send "Message sent: " + response.message + "(success)"

  robot.respond /status_test (.*)/i, (msg) ->
    text = msg.match[1]
    from = msg.message.user.name
    mailOptions =
      from: "#{from} <alert@sendgrid.com>" # sender address
      to: "jacob@sendgrid.com, kyle.kern@sendgrid.com" # list of recipients
      subject: "New TEST Alert in 411 Room" # Subject line
      generateTextFromHTML: true
      html: "<p><b>This email has been generated to notify you that Support has issued a customer facing post and tweet. <br>For more detailed Support or Operational communications please follow this issue in the 411 HipChat room where we can provide updates.<br>Here’s the 411:</p></b></p><p>#{text}</p><p><i>Please keep the 411 HipChat room open for future updates.</i></p>" # html body

    sgTransport.sendMail mailOptions, (error, response) ->
      if error
        console.log error
        msg.send "SG Error: " + error.data
        sgTransport.close()

        bkTransport.sendMail mailOptions, (error, response) ->
          if error
            bkTransport.close()
            console.log error
            msg.send "Backup error: " + error.data 
            msg.send "Do you want me to sit in a corner and rust or just fall apart where I'm standing? (foreveralone)"
          else
            console.log "Message sent on Backup: " + response.message
            msg.send "Message sent on Backup: " + response.message
      else
        msg.send "@all Status: " + text
        console.log "Message sent: " + text + response.message
        msg.send "Message sent: " + response.message + "(fuckyeah)"

