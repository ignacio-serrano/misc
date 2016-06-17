misc
====
General purpose storage

---
Probando probando 1,2,3


Below, a Git cheatsheet.

    git clone https://github.com/ignacio-serrano/misc.git

Clones this repository in current directory.

    git status

Tells what has changed in current working tree.

    git add .

Adds all working tree changes in current directory to the _stage_

    git commit -m "«Your commit message here»"

Takes all changes in the _stage_ and makes a commit out of them.

    git commit -a -m "«Your commit message here»"

`git add .` and `git commit -m` combined in a single command.

    git push

Sends all commits from local repository to remote repositories.

---

Below, a markdown cheatsheet.

Heading
=======
Sub-heading
-----------
### Another deeper heading

---

Paragraphs are separated
by a blank line.

Two spaces at the end of a line leave a  
line break.

Text attributes _italic_, *italic*, __bold__, **bold**, `monospace`.

Bullet list:

  * apples
  * oranges
  * pears

Numbered list:

  1. apples
  2. oranges
  3. pears

A [link](http://example.com).

```javascript
function {
  //Javascript highlighted code block.
}
```

    {
    Code block without highlighting.
    }
