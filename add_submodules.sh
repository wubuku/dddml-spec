#!/bin/bash

# Create @example-repos directory if it doesn't exist
mkdir -p @example-repos

# Function to add a submodule if it doesn't exist already
add_submodule() {
  local repo_url=$1
  local target_dir=$2
  
  if grep -q "$target_dir" .gitmodules 2>/dev/null; then
    echo "Submodule $target_dir already exists, skipping..."
  else
    echo "Adding submodule $repo_url to $target_dir"
    git submodule add $repo_url $target_dir
  fi
}

# Add git submodules
add_submodule https://github.com/wubuku/infinite-sea.git @example-repos/infinite-sea
add_submodule https://github.com/dddappp/A-AO-Demo.git @example-repos/A-AO-Demo
add_submodule https://github.com/dddappp/AI-Assisted-AO-Dapp-Example.git @example-repos/AI-Assisted-AO-Dapp-Example
add_submodule https://github.com/wubuku/hello-mud.git @example-repos/hello-mud
add_submodule https://github.com/wubuku/aptos-infinite-seas.git @example-repos/aptos-infinite-seas
add_submodule https://github.com/dddappp/sui-interface-demo.git @example-repos/sui-interface-demo
add_submodule https://github.com/dddappp/sui-flex-swap.git @example-repos/sui-flex-swap
add_submodule https://github.com/wubuku/Dapp-LCDP-Demo.git @example-repos/Dapp-LCDP-Demo
add_submodule https://github.com/wubuku/CLM.git @example-repos/CLM
add_submodule https://github.com/wubuku/FreshFruitAndVegetableTraceability.git @example-repos/FreshFruitAndVegetableTraceability

# Initialize and update submodules
git submodule init
git submodule update

echo "All repositories have been added as git submodules under @example-repos/"