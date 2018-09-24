# docker-notifier

Light-weight Docker container allowing for multiple forms of communication to be made, Slack and Email, to start

## CMD email

Currently undocumented

## CMD slack

Sends Messages or Files to Slack.

Variable inheritance hierarchy:

1. Values passed in as Arguments
2. Values present in env
3. Values passed in through slack.vars

```bash
$ docker run --rm gcr.io/cloud-builders-un-life/notifier slack

No Filename, Message, or Attachment defined.

Usage: slack [OPTION]... MESSAGE

    This script will use a Bot or User api key to post using the Slack web api.
        - https://api.slack.com/web

    This can only handle one message or file at a time.

    This does not use the incoming webhooks plugin. Let me know if you want that to be an option.
        - trentdavidaa@gmail.com

  -c CHANNEL_ID     Slack channel to target.
  -f FILENAME       File to upload to Slack.
                    - ignores -a flag
  -u SLACK_API_URL  URL to Slack api.
                    - Defaults to 'https://slack.com/api'
  -a "ATTACHMENTS"  Preformatted payload attachments string.
                    - ignored if -f
                    - escape your quotes
                    - renders like '"attachments":[]'
                    - https://api.slack.com/methods/chat.postMessage
  -k SLACK_API_KEY  Slack API Key.
                    - Starts like "xoxb-##########-############-***************"
  -t SLACK_TS       Timestamp of message to update.
  -h                display help
  ```