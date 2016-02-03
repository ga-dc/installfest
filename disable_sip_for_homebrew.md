# El Capitan & Homebrew

Part of the OS X 10.11/El Capitan changes is something called [System Integrity Protection](https://en.wikipedia.org/wiki/System_Integrity_Protection) or "SIP".

We need to create the '/usr/local/' directory to support installing Homebrew.  To do that we need to disable SIP, which requires a reboot.

1. Reboot into Recovery mode (Hold Cmd+R on boot) & 
2. Start the Terminal, from the Utilities menu.
3. Disable SIP:

    $ csrutil disable

4. Reboot back into OS X
5. Now that SIP is disabled, you can restart the rake command:

    $ cd ~/wdi
    $ rake installfest:start
