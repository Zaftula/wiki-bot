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
  service: "Hotmail"
  auth:
    user: "jacobleesg@hotmail.com",
    pass: "03jAc*b"
)

module.exports = (robot) ->
  emailTime = null
  robot.respond /status (.*)/i, (msg) ->
    #sendEmail msg.match[1], msg.message.user.name
    text = msg.match[1]
    from = msg.message.user.name
    mailOptions =
      from: "#{from} <alert@sendgrid.com>" # sender address
      to: "jacob@sendgrid.com" # list of receivers
      subject: "SendGrid Status Alert" # Subject line
      generateTextFromHTML: true
      html: "<p><b>A Status Alert has been generated:</b></p><p>#{text}</p><p>For details, please go to the HipChat Support room.</p>" # html body

    sgTransport.sendMail mailOptions, (error, response) ->
      if error
        console.log error
        msg.send "SG Error: " + error
        sgTransport.close()

        bkTransport.sendMail mailOptions, (error, response) ->
          if error
            bkTransport.close()
            console.log error
            msg.send "Backup error: " + error + " Do you want me to sit in a corner and rust or just fall apart where I'm standing? (foreveralone)"
          else
            console.log "Message sent on Backup: " + response.message
            msg.send "Message sent on Backup: " + response.message
      else
        console.log "Message sent: " + text + response.message
        msg.send "Message sent: " + response.message + "(fuckyeah)"
