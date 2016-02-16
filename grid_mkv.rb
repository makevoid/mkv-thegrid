require_relative 'lib/saf'

def site_path(name)
  "config/site-#{name}.saf"
end

site = Saf.load site_path(:mkv)

p site
