# Creating a new Rails app

### Setup the dev environment

- Create a new, empty folder anywhere on your machine.
- Open that folder in VSCode
- Search in the Command Palette for "Reopen in Container", and select the dev container option
    - Choose the Add to Workspace option
    - Search for Ruby and pick the top option
    - When asked what additional packages you want, select "npm node and yarn" option
    - decline, or choose defaults for the rest of the questions
- Once VSCode reopen, open a terminal in VSCode. You'll notice that you're in a linux environment with ruby installed. From here run `gem install rails` to install the latest version of Rails
- once it's installed run `rails new . -d postgresql --devcontainer -m TODO<put the template here>`. When asked if you want to override files, say `y`.

That's it! you've got a fully configured Polyar Rails app!.

### Secrets and Environment Variables

We use dotenv vault for managing secrets and environment variables.
- From the VSCode terminal run `npx dotenv-vault@latest new` Follow all the instructions and you should be good to go.
