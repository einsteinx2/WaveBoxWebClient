guard 'livereload' do
  watch(%r{.+\.(css|js|html)$}) 
end

# Add files and commands to this file, like the example:
#   watch(%r{file/path}) { `command(s)` }
#
guard 'shell' do
  watch(/(.*).coffee/) { `cake build` }
end
