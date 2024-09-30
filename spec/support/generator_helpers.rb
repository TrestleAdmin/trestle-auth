module Trestle
  module Auth
    module Test
      module GeneratorHelpers
        def stub_model_file(name="Administrator")
          stub_file "app/models/#{name.underscore}.rb", <<~EOF
            class #{name} < ApplicationRecord
            end
          EOF
        end

        def stub_file(path, contents)
          filepath = file(path)

          FileUtils.mkdir_p(filepath.dirname)
          File.open(filepath, "w") { |f| f.write(contents) }
        end
      end
    end
  end
end
