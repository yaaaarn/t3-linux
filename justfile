build:
    git add . 
    nix build .#packages.x86_64-linux.default |& nom

clean:
    rm -rf result

test:
    git add .
    nix run .#nixosConfigurations.default.config.system.build.vm |& nom
