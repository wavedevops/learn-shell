That's great to hear, Hari! 🎉 Since you've completed your application setup using shell scripts and modular functions, now is the perfect time to **note down key lessons, best practices, and common mistakes to avoid** — so you don’t repeat them in the future.

Here’s a **checklist + notes format** you can use to review and improve your process:
## **Give me checklist-style notes to avoid mistakes like last time**
<span style="color:red">This is red</span>
---

# 📝 My Notes

## ✅ Step 1: Setup NodeJS

<span style="color:green">✔ NodeJS module disabled</span>  
<span style="color:green">✔ NodeJS 20 enabled</span>  
<span style="color:green">✔ NodeJS dependencies installed</span>

---

## ⚠️ Step 2: Schema Setup

<span style="color:orange">⚠ Make sure you define `schema_type=mongo` before calling the function</span>  
<span style="color:red">❌ Don't call function before setting variables</span>

---

## 🔍 Common Mistakes

- <span style="color:red">❌ Forgot `code_check` after major steps</span>
- <span style="color:red">❌ Wrong order: function called before variable defined</span>
- <span style="color:orange">⚠ Variable name mismatch</span>
- <span style="color:green">✅ All corrections applied and tested</span>

---

## 📌 Notes

- <span style="color:blue">Use emoji + HTML for better visibility in local Markdown preview</span>
- <span style="color:gray">Colors won't show on GitHub Markdown preview</span>


---

## ✅ **Shell Scripting — Final Review Notes & Best Practices**

### 🟩 **1. File Structure**

* [ ] Always keep a **common.sh** file for reusable functions (e.g., `print_head`, `code_check`, `download_and_extract`, etc.).
* [ ] Each component (catalogue, user, cart, etc.) should have its own script calling the common functions.

---

### 🟩 **2. Variable Usage**

* [ ] **Declare variables before using them in functions**.

    * Example: `schema_type=mongo` should come **before** `schema_setup`.
* [ ] Use variables like `component`, `app_user`, etc., to avoid hardcoded values.
* [ ] Be consistent with variable **naming** — use lowercase and underscores.

---

### 🟩 **3. Function Design**

* [ ] Each function should do **one clear job** (single responsibility).
* [ ] Add `print_head` before every major task for visibility in logs.
* [ ] Always run `code_check` after a command to verify success or failure.

---

### 🟩 **4. Function Execution Order**

* [ ] The **order of function calls matters**:

  ```bash
  component=catalogue
  schema_type=mongo
  nodejs_app_setup
  ```

    * Wrong order leads to skipped logic or failure.

---

### 🟩 **5. Error Handling**

* [ ] Use `code_check` after each command that may fail.
* [ ] Use `exit 1` to **stop execution** when critical steps fail.
* [ ] Redirect logs (e.g., `&>>$LOG_FILE`) if you want to keep logs later.

---

### 🟩 **6. Reusability**

* [ ] Modularize your script so it works for any component.
* [ ] Use `component` variable and pass values from external files.

---

### 🟩 **7. Permissions**

* [ ] Run the script as root or use `sudo` when needed.
* [ ] Ensure correct ownership and permissions for files/directories.

---

### 🟩 **8. SystemD Integration**

* [ ] Use `cp`, `daemon-reload`, `enable`, `restart` in correct order.
* [ ] Service file must exist and be correctly named (`${component}.service`).

---

### 🟩 **9. Schema Setup**

* [ ] Only execute `schema_setup` if `schema_type` is set.
* [ ] Support for multiple DB types? Use `if-else` for different `schema_type` values.

---

### 🟩 **10. Final Tips**

* [ ] Test each function separately before combining them.
* [ ] Practice writing and reading scripts to improve speed.
* [ ] Always test with real URLs and file paths.

---

Do you want me to give you this as a Markdown file or save it in a note-style format for easy access?
