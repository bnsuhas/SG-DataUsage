# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def common_pods
    pod 'Reachability'
end

target 'SG-DataUsage' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  common_pods
  
  target 'SG-DataUsageTests' do
    inherit! :search_paths
    common_pods
  end

  target 'SG-DataUsageUITests' do
    inherit! :search_paths
    common_pods
  end

end
