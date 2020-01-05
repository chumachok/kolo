# Kolo
Kolo is a simple app generator for building a bare-bones Roda/Sequel stack apps running on top of PosgreSQL database.

## Usage:
```
gem install kolo-roda

kolo new <app_name> --config_file <path> --template_dir <path>
cd <app_name>

bundle install
rake db:create
rackup
```
