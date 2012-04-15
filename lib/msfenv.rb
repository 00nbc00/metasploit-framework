#
# Shim load the bundled gem cache if the environment is set
#

_msf_gemcache = false

# If the bundle option is explicitly set, load the gemcache
if ENV['MSF_BUNDLE_GEMS'].to_s.downcase =~ /^[yt1]/
	require 'msf/env/gemcache'
	_msf_gemcache = true
else
	# If the bundle option is empty and this looks like an installer environment
	# also load the gem cache (but probably not the binary gem cache)
	if ENV['MSF_BUNDLE_GEMS'].to_s.length == 0 and 
		::File.exists?( File.join( File.dirname(__FILE__), "..", "..", "properties.ini") ) and
		::File.directory?( File.join( File.dirname(__FILE__), "..", "..", "apps", "pro") )
			require 'msf/env/gemcache'
			_msf_gemcache = true
	end
end

if not _msf_gemcache
	# The user is running outside of the installer environment and not using
	# our bundled gemset, so we fallback on bundler instead
	ENV['BUNDLE_GEMFILE'] = ::File.expand_path(::File.join(::File.dirname(__FILE__), "..", "documentation", "Gemfile"))
	ENV['BUNDLE_PATH']    = ENV['GEM_HOME']
	require 'bundler/setup'
end
