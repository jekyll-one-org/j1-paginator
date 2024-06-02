# Gem build notes
# ------------------------------------------------------------------------------
# create:                             gem build j1-paginator.gemspec
# list all local:                     gem list j1-paginator --local --all
# list all remote:                    gem list j1-paginator --remote --all
# publish (RubyGems):                 gem push j1-paginator-2024.1.0.gem
# un-publish (RubyGems):              gem yank j1-paginator -v 2024.1.0
# install (local):                    gem install j1-paginator-2024.1.0.gem
# install (manually, user):           gem install --local j1-paginator --user-install --no-document
# install (manually, user):           gem install j1-paginator-2024.1.0.gem --user-install --no-document
# install (remote):                   gem install j1-paginator
# uninstall (all):                    gem uninstall j1-paginator --force
# uninstall (version/user/forced):    gem uninstall j1-paginator -v 2024.1.0 --user --force
# uninstall (version/system):         gem uninstall j1-paginator -v 2024.1.0 --force


# When modifying remember to issue a new tag command in git before committing,
# then push the new tag
#
#   git tag -a 2024.1.0 -m "2024.1.0"
#   git push origin --tags

git rm -r --cached . && git add .
git commit -am "New version 2024.1.0"
