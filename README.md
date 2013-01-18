# puppet-ccfe

Puppet module for creating menus and menu items using the Curses Command
Front-end (CCFE) menu system - http://cfe.altervista.org/en/

Currently only tested on Redhat-like systems.

## Usage

The recommended usage is to place the configuration in a hiera config file and
just include the ccfe module in your puppet configuration:

    include ccfe

Example hiera config:

    ccfe::filestore:    'puppet:///files/ccfe',
    ccfe::package_file: 'ccfe-1.57-1.noarch.rpm'
    ccfe::menu_wrapper: 'true'
    
    ccfe::menus:
      menu:
        description: 'Main Menu'
        items:
          user_services:
            description: 'User Services'
            action: 'menu:services'
          system_services:
            description:  'System Services'
            action: 'run:/sbin/service --status-all'
      services:
        description: 'Logscape'
        group: 'logscape'

    ccfe::items:
      01_logscape_taillogfile:
        parent: 'services'
        group: 'logscape'
        description: 'logscape service: tail log file'
        action: 'run:/usr/bin/sudo -Hi -u logscape /usr/bin/tail -n 100 -f ~logscape/logs/logscape/current'
      02_logscape_status:
        parent: 'services'
        group: 'logscape'
        description: 'logscape service: status'
        action: 'run:/usr/bin/sudo -Hi -u logscape /sbin/sv -w60 stat logscape'
      03_logscape_restart:
        parent: 'services'
        group: 'logscape'
        description: 'logscape service: status'
        action: 'run:/usr/bin/sudo -Hi -u logscape /sbin/sv -w60 stat logscape'

This example does the following:

* Creates a */usr/bin/menu* wrapper script that calls */usr/bin/ccfe menu* to
  display the menu called *menu*

* Creates a menu called *menu* with a *User Services* entry and a *System Services* entry

* Selecting the *System Services* entry executes */sbin/service* to show the status of system services

* Selecting the *User Services* entry calls another menu called *services*

* For members of the *logscape* group (and the owner *root*) the *services*
  menu has three items and selecting each of these runs a command.  Non-members
  will not see these menu items.

If the contents of the menu is known beforehand then it can be constructed
completely using the ccfe::menus configuration in hiera or calling the
ccfe::menus parameterised class with an appropriate config parameter hash.

To dynamically add menu items the ccfe::items configuration in hiera or
ccfe::items parameterised class can be used. The menus themselves must already
have been created using ccfe::menus though.

If menu_wrapper is set to true, which it is by default, then your top-level
menu should be called *menu* and will be displayed when the */usr/bin/menu*
command is executed.

If the group parameter is passed when creating a menu then only members of that
group (and the owner - usually root) will be able to access the menu.  Any menu
items under this menu will have the same restrictions.

If the group parameter is passed when creating a menu item then only members of
that group (and the owner - usually root) will see that item on the menu.  This
can be used to provide additional menu items to a certain group while hiding
them from others.

## ccfe

*basedir*: The base directory under which menus are created. Default: */usr/lib/ccfe/ccfe*

*filestore*: The Puppet Master file store location where the CCFE package file
is located. Default: *puppet:///files/ccfe*

*package_file*: The CCFE package filename. Default: *ccfe-1.57-1.noarch.rpm*

*menu_wrapper*: Whether or not to create the */usr/bin/menu* wrapper script so
users can just type *menu*. Default: true

*workspace*: The directory on the Puppet agent host that is used to store the
package file before it is installed. Default: */root/ccfe*

## ccfe::menus

Class that creates ccfe::menu resources from a ccfe::menus hash in hiera or the
config parameter.

## ccfe::menu

*title*: The unique menu id.

*description*: The title that will be displayed above the menu.  Default: $title

*user*: The user that the menu files will be owned by. Default: *root*

*group*: The group that the menu files will be owned by. Default: *root*

*items*: A hash of ccfe::item resources to create under this menu. Default: {}

## ccfe::items

Class that creates ccfe::item resources from a ccfe::menus hash in hiera or the
config parameter.

## ccfe::item

*title*: The unique menu item id

*parent*: The parent menu that this item is part of. Required.

*action*: The action to take when this meny item is selected.  Can be either *menu:[menu name]* to select another menu or *run:[command]* to execute a command. Required.

*user*: The user that the menu files will be owned by. Default: *root*

*group*: The group that the menu files will be owned by. Defaukt: *root*

*description*: The menu item description that is displayed.  Default: $title

## Notes

Not all CCFE functionality is supported and in particular support for forms in
missing.

## Support

License: Apache License, Version 2.0

GitHub URL: https://github.com/erwbgy/puppet-ccfe
