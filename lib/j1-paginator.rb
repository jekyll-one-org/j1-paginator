# Jekyll::Paginate V2 is a gem built for Jekyll 3 that generates pagiatation for posts, collections, categories and tags.
# 
# It is based on https://github.com/jekyll/jekyll-paginate, the original Jekyll paginator
# which was decommissioned in Jekyll 3 release onwards. This code is currently not officially
# supported on Jekyll versions < 3.0 (although it might work)
#
# Author: Sverrir Sigmundarson
# Site: https://github.com/sverrirs/j1-paginator
# Distributed Under The MIT License (MIT) as described in the LICENSE file
#   - https://opensource.org/licenses/MIT

require "j1-paginator/version"
# Files needed for the pagination generator
require "j1-paginator/generator/defaults"
require "j1-paginator/generator/compatibilityUtils"
require "j1-paginator/generator/utils"
require "j1-paginator/generator/paginationIndexer"
require "j1-paginator/generator/paginator"
require "j1-paginator/generator/paginationPage"
require "j1-paginator/generator/paginationModel"
require "j1-paginator/generator/paginationGenerator"
# Files needed for the auto category and tag pages
require "j1-paginator/autopages/utils"
require "j1-paginator/autopages/defaults"
require "j1-paginator/autopages/autoPages"
require "j1-paginator/autopages/pages/baseAutoPage"
require "j1-paginator/autopages/pages/categoryAutoPage"
require "j1-paginator/autopages/pages/collectionAutoPage"
require "j1-paginator/autopages/pages/tagAutoPage"

module Jekyll 
  module J1Paginator
  end # module J1Paginator
end # module Jekyll