# El Capitan & Homebrew

Part of the OS X 10.11/El Capitan changes is something called [System Integrity Protection](https://en.wikipedia.org/wiki/System_Integrity_Protection) or "SIP".

To install Homebrew we'll need to disable SIP. Note that the steps below involve restarting and using Recovery Mode, in which you will not have access to Safari. So you may want to print out this page, write down the steps, or open it on another device (e.g. your phone) so that you can continue to read the instructions while in Recovery.

[Here's a so-so video of this process](https://www.youtube.com/watch?v=7Dgg5XAYMXI) (not made by GA).

1. Reboot into Recovery Mode (Hold Cmd+R on boot) 
2. From the "Utilities" menu select "Terminal"
3. Disable SIP with this command:
    ```
    $ csrutil disable
    ```

4. Reboot back into OS X (from the Apple &#63743; menu, select "Restart")
5. Now that SIP is disabled, you can restart the rake command:
    ```
    $ cd ~/wdi
    
    $ rake installfest:start
    ```
