# kolo
kolo is a simple app generator for building bare-bones Roda/Sequel stack apps running on top of PosgreSQL database.

## usage:
```
gem install kolo-roda

kolo new <app_name> --config_file <path> --template_dir <path>
cd <app_name>

bundle install
rake db:create
rackup
```
