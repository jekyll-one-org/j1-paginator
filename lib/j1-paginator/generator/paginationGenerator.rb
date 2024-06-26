module Jekyll
  module J1Paginator::Generator

    #
    # The main entry point into the generator, called by Jekyll
    # this function extracts all the necessary information from the jekyll end and passes it into the pagination
    # logic. Additionally it also contains all site specific actions that the pagination logic needs access to
    # (such as how to create new pages)
    #
    class PaginationGenerator < Generator
      # This generator is safe from arbitrary code execution.
      safe true

      # This generator should be passive with regard to its execution
      priority :lowest

      # Generate paginated pages if necessary (Default entry point)
      # site - The Site.
      #
      # Returns nothing.
      def generate(site)

        # Retrieve and merge the pagination configuration from the
        # plugin yml file
        pg_config_defaults = site.data['plugins']['defaults']['paginator']
        pg_config_settings = site.data['plugins']['paginator']
        pg_settings = Jekyll::Utils.deep_merge_hashes(pg_config_defaults, pg_config_settings || {})

        # Merge the pagination configuration by the site default settings
        # default_config = Jekyll::Utils.deep_merge_hashes(DEFAULT, site.config['pagination'] || {})#
        default_config = Jekyll::Utils.deep_merge_hashes(DEFAULT, pg_settings['settings']['pagination'] || {})
        # default_config = pg_settings

        # Compatibility Note: legacy paginate logic NOT supported by
        # J1 Paginator. If the legacy paginate logic is configured then
        # raise error
        if !site.config['paginate'].nil?
          Jekyll.logger.info "J1 Paginator:","legacy paginate configuration settings detected"
          err_msg = "J1 Paginator does NOT support the old jekyll-paginate logic. Please disable legacy 'paginate:' config settings"
          Jekyll.logger.error err_msg
          raise ArgumentError.new(err_msg)
        end # Compatibility END (REMOVE AFTER 2018-01-01)

        # If disabled then simply quit
        if !default_config['enabled']
          Jekyll.logger.info "J1 Paginator:","disabled"
          return
        else
          Jekyll.logger.info "J1 Paginator:","enabled"
        end

        # Generate the AutoPages first
        J1Paginator::AutoPages.create_autopages(site)

        # Handle deprecation of settings and features
        if( !default_config['title_suffix' ].nil? )
          Jekyll::Deprecator.deprecation_message "J1 Paginator: The 'title_suffix' configuration has been deprecated. Please use 'title'. See https://github.com/sverrirs/j1-paginator/blob/master/README-GENERATOR.md#site-configuration"
        end

        Jekyll.logger.info "J1 Paginator:","generate paginator pages: enabled"
#       Jekyll.logger.info "J1 Paginator:","generate paginator pages: start processing ..."

        ################ 0 ####################
        # Get all pages in the site (this will be used to find the pagination templates)
        all_pages = site.pages

        # Get the default title of the site (used as backup when there is no title available for pagination)
        site_title = site.config['title']

        #  lambda (callback functions)
        # ----------------------------------------------------------------------

        # Specify the callback function that returns the correct docs/posts
        # based on the collection name "posts" are just another collection in
        # Jekyll but a specialized version that require timestamps
        # This collection is the default and if the user doesn't specify a
        # collection in their front-matter then that is the one we load
        # If the collection is not found then empty array is returned
        collection_by_name_lambda = lambda do |collection_name|
          coll = []
          if collection_name == "all"
            # the 'all' collection_name is a special case and includes all collections in the site (except posts!!)
            # this is useful when you want to list items across multiple collections
            site.collections.each do |coll_name, coll_data|
              if( !coll_data.nil? && coll_name != 'posts')
                coll += coll_data.docs.select { |doc| !doc.data.has_key?('pagination') } # Exclude all pagination pages
              end
            end
          else
            # Just the one collection requested
            if !site.collections.has_key?(collection_name)
              return []
            end

            coll = site.collections[collection_name].docs.select { |doc| !doc.data.has_key?('pagination') } # Exclude all pagination pages
          end
          return coll
        end

        # Create the proc that constructs the real-life site page
        # This is necessary to decouple the code from the Jekyll site object
        page_add_lambda = lambda do | newpage |
          # Add the page to the site so that it is generated correctly
          site.pages << newpage
          return newpage # Return the site to the calling code
        end

        # lambda that removes a page from the site pages list
        page_remove_lambda = lambda do | page_to_remove |
          site.pages.delete_if {|page| page == page_to_remove }
        end

        # Create a proc that will delegate logging
        # Decoupling Jekyll specific logging
        logging_lambda = lambda do | message, type="info" |
          if type == 'debug'
            Jekyll.logger.debug "J1 Paginator:","#{message}"
          elsif type == 'error'
            Jekyll.logger.error "J1 Paginator:", "#{message}"
          elsif type == 'warn'
            Jekyll.logger.warn "J1 Paginator:", "#{message}"
          else
            Jekyll.logger.info "J1 Paginator:", "#{message}"
          end
        end

        # Create and call the model with the real-life page creation
        # proc and site data
        model = PaginationModel.new(logging_lambda, page_add_lambda, page_remove_lambda, collection_by_name_lambda)
        count = model.run(default_config, all_pages, site_title)
        Jekyll.logger.info "J1 Paginator:", "generate paginator pages: #{count} template|s used"
#       Jekyll.logger.info "J1 Paginator:", "generate paginator pages: finished"

      end # function generate
    end # class PaginationGenerator

  end # module J1Paginator
end # module Jekyll
