# Setup

The project is dockerized, this means that all commands and the web server can be run by using docker containers. This should be the easier way to run the application and the setup is being made automatically at the first run by using docker commands, without any installation of the database, language and libraries.

You just need to have [docker](https://docs.docker.com/engine/installation/) and [docker-compose](https://docs.docker.com/compose/install/) installed. With these two tools ready, you can run the application by folling the section to [start the APP](https://github.com/williamweckl/star_wars_api/blob/main/README.md#start).

If you wish, you can still install Elixir language and run this project. I usually prefer this approach when I'm an active developer of the project because integrating IDE's or other tools to write code with linters and other language tools can be painfull. If you want, [here is a guide to install Elixir using ASDF](https://github.com/williamweckl/star_wars_api/blob/main/priv/doc/using-elixir-with-asdf.md).

You can also install the language by common ways (without ASDF or other version tool), but I don't recommend it because it would be very difficult to handle the case that you have multiple projects using different versions of Elixir/Erlang in your machine and also version upgrades could be easier by using a tool like ASDF.

## Database structure

The database structure setup will happen at the first start of the server without aditional setup or configuration.
