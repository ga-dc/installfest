# Welcome to Installfest

You will be using [rake](https://github.com/ruby/rake) (a ruby tool for managing commands) to install the apps you will be using throughout your career.

**Please read this whole page!** You're going to be installing a lot of stuff on your computer in a way you probably never have before.

Read through every instruction carefully and follow them **to the letter**.  Computers require a significant attention to detail.

## What's Going On

This script is going to check for different pieces of software on your computer. If you don't have those pieces of software -- or you do, but they need to be tweaked -- the script will stop and tell you how to install them. When you're done, the script will restart and check again. This will continue until everything is set up correctly.

## Getting Set Up

Open Terminal by:

- Typing "Terminal" into Spotlight (ensure you select the Terminal app). Open Spotlight by clicking the little magnifying glass in the top-right corner of your screen, or hitting Command + Space. **Or...**

- In the Finder, going to the "Applications" folder, then "Utilities", then double-clicking "Terminal".

You should have **two terminal windows** open at the same time: one in which this script is running, and one in which you can type stuff. This is because you can't type stuff into the window in which this script is running -- you can only hit the "return" key when prompted. Open a new window by pressing Command + N. There's going to be a lot of text, so make the windows as TALL as you can.

If you have ANY questions, raise your hand for assistance.

## Talking to Terminal

You'll be prompted to enter commands into Terminal. The commands will look something like this:

```
$ echo "Hello, world!"
$ echo "My name is MY_NAME!"
```

- You should be able to **copy and paste** the lines into Terminal. We don't recommend typing the commands manually since a single typo can make a command malfunction.

- Copy and paste **one command at a time**. Each command should be a single line, but if your window is narrow some lines may "wrap" and appear as multiple lines. Most commands will begin with a dollar sign (`$`). On that note...

- You **should not** include the `$` when copying and pasting. Instead, copy and paste everything AFTER it. The dollar sign is an industry convention that signals "This is an individual command to be copied and pasted."

<<<<<<< HEAD
- If you see words in all-capitals (like "MY_NAME"), replace them with whatever's appropriate.

- It doesn't matter what directory you're in when entering commands.

- Generally-speaking, if you get a **WARNING** you can ignore it, unless it prevents the Installfest script from continuing. An **ERROR**, however, will need to be fixed.

- Terminal is not big on **visual feedback**:

  - Terminal usually doesn't tell you when something worked. No news is good news. If you enter a command and Terminal doesn't say anything about it, it probably worked fine.

  - If you're asked to enter your password, that means the password for your computer. When you type it in, Terminal won't give you any visual feedback to indicate you're typing things in: you won't get a black dot for each character you typed. That's OK: just type your password and hit enter.

## Downloading the Script

1. Make your working directory for WDI.  You will use this directory *throughout the course* for storing exercises, homework, projects, and so on:

  ```
  mkdir ~/wdi
  ```

2. Change to that directory:

  ```
  cd ~/wdi
  ```

3. Download the latest Installfest Rakefile to this directory (via `curl` command). This will actually download *two* files: `Rakefile` and `installfest.yml`.

  ```
  curl --location https://git.io/vLxbY | sh
  ```

4. Run the Rake command:

  ```
  rake installfest:start
  ```
