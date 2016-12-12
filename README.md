# PControlBot

Ultra simple script for remote control via Telegram Bot using the [telegram-bot-ruby](https://github.com/atipugin/telegram-bot-ruby) wrapper.

## Commands

- Unauthenticated
  - `/start` - Show cute start message.
  - `/login <password>` - Authenticate.
- Authenticated
  - `/renew` - Renew password.
  - `/logout` - Log out from session.
  - `/kill` - Kill bot service.

When unauthenticated, the bot will reply every other message with a random picture. When authenticated, it'll run and reply the requested command's `stdout`.
