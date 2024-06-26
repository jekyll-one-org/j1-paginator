module Jekyll
  module J1Paginator::AutoPages

    # This function is called right after the main generator is triggered by
    # Jekyll. This code is adapted from Stephen Crosby's code.
    # See: https://github.com/stevecrozz
    def self.create_autopages(site)

      # Retrieve and merge the pagination configuration from the plugin yml file
      pg_config_defaults = site.data['plugins']['defaults']['paginator']
      pg_config_settings = site.data['plugins']['paginator']
      pg_settings = Jekyll::Utils.deep_merge_hashes(pg_config_defaults, pg_config_settings || {})

      # Get the configuration for auto pages
      ap_config_defaults = pg_config_defaults['defaults']['autopages']
      ap_config_settings = pg_config_settings['settings']['autopages']
      ap_settings = Jekyll::Utils.deep_merge_hashes(ap_config_defaults, ap_config_settings || {})

      # Merge the auto page configuration by the site default settings
      autopage_config = Jekyll::Utils.deep_merge_hashes(DEFAULT, ap_settings || {})


      # Get the configuration for the paginator
      pg_config_defaults = pg_config_defaults['defaults']['pagination']
      pg_config_settings = pg_config_settings['settings']['pagination']
      pg_settings = Jekyll::Utils.deep_merge_hashes(pg_config_defaults, pg_config_settings || {})

      # Merge the pagination configuration by the GENERATOR default settings
      pagination_config = Jekyll::Utils.deep_merge_hashes(Jekyll::J1Paginator::Generator::DEFAULT, pg_settings || {})

      # If disabled then don't do anything
      if !autopage_config['enabled'] || autopage_config['enabled'].nil?
        Jekyll.logger.info "J1 Paginator:", "generate auto pages: disabled"
        return
      end

      # TODO: Should I detect here and disable if we're running the
      #       legacy paginate code???!

      # Simply gather all documents across all pages/posts/collections
      # Could be generated quite a few empty pages but the logic is just
      # vastly simpler than trying to figure out what tag/category belong
      # to which collection.
      posts_to_use = Utils.collect_all_docs(site.collections)

      ###############################################
      # Generate the Tag pages if enabled
      createtagpage_lambda = lambda do | autopage_tag_config, pagination_config, layout_name, tag, tag_original_name |
        site.pages << TagAutoPage.new(site, site.dest, autopage_tag_config, pagination_config, layout_name, tag, tag_original_name)
      end
      autopage_create(autopage_config, pagination_config, posts_to_use, 'tags', 'tags', createtagpage_lambda) # Call the actual function


      ###############################################
      # Generate the category pages if enabled
      createcatpage_lambda = lambda do | autopage_cat_config, pagination_config, layout_name, category, category_original_name |
        site.pages << CategoryAutoPage.new(site, site.dest, autopage_cat_config, pagination_config, layout_name, category, category_original_name)
      end
      autopage_create(autopage_config, pagination_config, posts_to_use, 'categories', 'categories', createcatpage_lambda) # Call the actual function

      ###############################################
      # Generate the Collection pages if enabled
      createcolpage_lambda = lambda do | autopage_col_config, pagination_config, layout_name, coll_name, coll_original_name |
        site.pages << CollectionAutoPage.new(site, site.dest, autopage_col_config, pagination_config, layout_name, coll_name, coll_original_name)
      end
      autopage_create(autopage_config, pagination_config,posts_to_use, 'collections', '__coll', createcolpage_lambda) # Call the actual function

    end # create_autopages

    # STATIC: this function actually performs the steps to generate the autopages.
    #   It uses a lambda function to delegate the creation of the individual
    #   page types to the calling code (this way all features can reuse the
    #   logic).
    #
    def self.autopage_create(autopage_config, pagination_config, posts_to_use, configkey_name, indexkey_name, createpage_lambda )
      if !autopage_config[configkey_name].nil?
        ap_sub_config = autopage_config[configkey_name]
        if ap_sub_config ['enabled']
          Jekyll.logger.info "J1 Paginator:","autopages, generating #{configkey_name} pages"

          # Roll through all documents in the posts collection and extract the tags
          # Cannot use just the posts here, must use all things.. posts, collections...
          index_keys = Utils.ap_index_posts_by(posts_to_use, indexkey_name)

          index_keys.each do |index_key, value|
            # Iterate over each layout specified in the config
            ap_sub_config ['layouts'].each do | layout_name |
              # Use site.dest here as these pages are never created in the
              # actual source but only inside the _site folder
              createpage_lambda.call(ap_sub_config, pagination_config, layout_name, index_key, value[-1]) # the last item in the value array will be the display name
            end
          end
        else
          Jekyll.logger.info "J1 Paginator:","autopages, #{configkey_name} pages are disabled"
        end
      end
    end

  end # module J1Paginator
end # module Jekyll
