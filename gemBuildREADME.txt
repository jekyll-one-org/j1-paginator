# Gem build notes
# ------------------------------------------------------------------------------
# create:                   gem build j1-paginator.gemspec
# list all local:           gem list j1-paginator --local --all
# list all remote:          gem list j1-paginator --remote --all
# publish (RubyGems):       gem push j1-paginator-2020.0.2.gem
# un-publish (RubyGems):    gem yank j1-paginator -v 2020.0.2
# install (local):          gem install --local j1-paginator
# install (remote):         gem install j1-paginator
# uninstall (all):          gem uninstall j1-paginator --force
# uninstall (version):      gem uninstall j1-paginator -v 2020.0.2 --force


# When modifying remember to issue a new tag command in git before committing,
# then push the new tag
#
#   git tag -a v2020.0.2 -m "v2020.0.2"
#   git push origin --tags
