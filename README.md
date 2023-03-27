# FAST Update
*(Mostly) Automatic FAST reconciliation for Hyrax-based repositories*

The University of Victoria Libraries uses FAST Update in production as part of [Vault](https://vault.library.uvic.ca/), its Digital Asset Management System.

## Requirements
* [Hyrax](https://github.com/samvera/hyrax), v.3.0.X and associated gems (e.g. Nokogiri, Blacklight, Sidekiq)
* [SimpleXlsxReader](https://github.com/woahdae/simple_xlsx_reader) - for reading/parsing .xslx (Microsoft Excel) files from OCLC FAST
* RSpec for testing
* Optional: [sidekiq-cron](https://github.com/sidekiq-cron/sidekiq-cron) for scheduling recurring updates every X number of days/weeks/months

## Usage
At present, the files in the repo would need to be copied into the root directory of your Hyrax/Rails app, following the exact structure of directories and files—with the exception of 3 files described in Configuration below. Development work is underway to transform these files into a gem for easier installation.

Run `rails db:migrate` after copying the files over.

## Configuration

There are 2 files whose contents need to be copy/pasted into your corresponding app files:

### config/routes.rb

```ruby
Rails.application.routes.draw do

# ... your own application code here ...

  get '/fast_update/replace_uri', to: 'fast_update/changes#index', as: :fast_update_replace_uri
  get '/fast_update/search_preview', to: 'fast_update/changes#search_preview', as: :fast_update_search_preview
  get '/fast_update/search_preview/page/:page', to: 'fast_update/changes#search_preview'

  namespace :fast_update do
    resources :changes, except: [:update, :edit]
  end
# ...
end
```

### config/settings.yml
```yaml
# ... your own application code here ...

fast_update:
  other_changes_email: example@institution.edu # Recipient email address for obsolete/deprecated headings goes here

```

### app/controllers/hyrax/dashboard_controller.rb
FAST Update comes with a web interface for replacing or deleting a URI. To add a link to this page in the Hyrax dashboard sidebar, edit `app/controllers/hyrax/dashboard_controller.rb` like below:

```ruby
# Line 18
self.sidebar_partials = { activity: [], configuration: [], repository_content: [], tasks: ["hyrax/dashboard/sidebar/replace_or_delete_fast_uris"] }
```

If you're using sidekiq-cron, you may also want to create a `schedule.yml` file. See [the wiki](https://github.com/UVicLibrary/fast_update/wiki/New-and-Modified-Headings#scheduling-updates-with-sidekiq-cron) or the [sidekiq-cron documentation](https://github.com/sidekiq-cron/sidekiq-cron#getting-started) for more details.

## Screenshots
![The user interface for selecting Fast URIs to replace or delete in the repository. The Hyrax dashboard sidebar is on the left. In the middle are 3 form fields: one for selecting the URI to delete or replace, the second for selecting the action (replace or delete), the third for selecting whether to apply the change to the whole repository or to a single collection only.](https://raw.githubusercontent.com/UVicLibrary/fast_update/main/docs/replace_or_delete_fast_uris.jpg)
![Fast Update can search your repository for works that contain a specific URI. This image shows a table of search results for an example search for "Tiffany, Louis Comfort, 1848-1933". Results can be filtered by collection.](https://raw.githubusercontent.com/UVicLibrary/fast_update/main/docs/search_results.jpg)
![The sidebar link to the Fast Update page for replacing or deleting URIs from a repository.](https://raw.githubusercontent.com/UVicLibrary/fast_update/main/docs/sidebar_link.png)
![Possible status messages for jobs that replace or delete URIs from the repository. When a URI has been successfully replaced, the message says, "Success: X number of replacements made". When a URI has been successfully deleted, the message reads "Success". When an error occurs, the message says, "Error: contact administrator for details".](https://raw.githubusercontent.com/UVicLibrary/fast_update/main/docs/status_messages.jpg)
