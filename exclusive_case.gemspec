# frozen_string_literal: true

require_relative "lib/exclusive_case/version"

Gem::Specification.new do |spec|
  spec.name = "exclusive_case"
  spec.version = ExclusiveCase::VERSION
  spec.authors = ["Ajay Sharma"]
  spec.email = ["aj@ajsharma.com"]

  spec.summary = "Exhaustive case statements for Ruby to prevent unhandled cases"
  spec.description =  "A Ruby gem that provides exhaustive case statement functionality to prevent bugs " \
                      "from unhandled cases when new values are added to a system."
  spec.homepage = "https://github.com/ajsharma/exclusive_case"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"
  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/ajsharma/exclusive_case"
  spec.metadata["changelog_uri"] = "https://github.com/ajsharma/exclusive_case/blob/main/CHANGELOG.md"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
