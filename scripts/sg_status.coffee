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
#   hubot status <message> - Sends email with the <subject> <message> to address <user@email.com>
#
# Author:
#   jacobmovingfwd
#
# Additional Requirements
#   unix mail client installed on the system

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
  service: "Hotmail",
  auth:
    user: "jacobleesg@hotmail.com",
    pass: "03jAc*b84"
)

module.exports = (robot) ->
  emailTime = null
  sendEmail = (msg, from) ->
    # setup e-mail data with unicode symbols
    mailOptions =
      from: "#{from} <alert@sendgrid.com>" # sender address
      to: "jacob@sendgrid.com" # list of receivers
      subject: "SendGrid Status Alert" # Subject line
      generateTextFromHTML: true
      html: "<p><b>A Status Alert has been generated:</b></p><p>#{msg}</p><p>For details, please go to the HipChat Support room.</p>" # html body

    sgTransport.sendMail mailOptions, (error, response) ->
      if error
        console.log error
        msg.send "SG Error: " + error
        bkTransport.sendMail mailOptions, (error, response) ->
          if error
            console.log error
            msg.send "Backup error: " + error
            msg.send "I have a million ideas, but, they all point to certain death. (okay)"
          else
            console.log "Message sent on Backup: " + response.message
            msg.send "Message sent on Backup: " + response.message + "(fuckyeah)"
      else
        console.log "Message sent: " + response.message
        msg.send "Message sent: " + response.message + "(fuckyeah)"

  robot.respond /status (.*)/i, (msg) ->
    sendEmail msg.match[1], msg.message.user.name
