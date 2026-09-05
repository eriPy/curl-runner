# curl-runner

A simple interactive bash script that builds and runs `curl` commands for you — so you stop typing long curl commands by hand while testing a backend.

## What it does

Instead of writing a full `curl` command every time you want to test an endpoint, this script asks you a few questions and runs the request for you:

1. Asks whether you want to (re)set the **API name** and **port**.
2. Asks for the **endpoint** name.
3. Asks for the **HTTP method**.
   - If you leave it empty, it defaults to a plain **GET** request.
   - If you type any other method (POST, PUT, DELETE, etc.), it then loops asking for **key/value pairs** one at a time, and builds a JSON body from them automatically.
4. Builds the final `curl` command and executes it.
5. Loops back so you can fire another request right away, reusing the same API/port until you choose to change them.

Typing `end` at the endpoint or method prompt stops the script. Typing `prob` skips the current request and starts over.

## Why I built this

I wanted a first real project to learn bash beyond just running commands one at a time in the terminal. This project pushed me to actually write and run a **bash script**, not just individual commands — and to understand the syntax and structure behind it.

Through building this, I learned:

- How to create, give permissions to (`chmod +x`), and run a `.sh` script.
- Variables, and the fact that everything in bash is treated as a string.
- `read` for taking user input, including prompts and default values.
- Conditionals (`if` / `elif` / `else` / `fi`) and comparing strings vs numbers.
- Loops (`while true`, `break`, `continue`) to keep asking for input until a stop condition is met.
- String manipulation with parameter expansion (like `${var%,}` to trim a trailing character).
- Why building a command as a single string and running it can break (word-splitting, quoting issues), and why using a **bash array** to build a command (`cmd=(curl -X "$method" ...)` + `"${cmd[@]}"`) is the correct, safe approach.
- Practical use of `curl` flags: `-X` for the method, `-H` for headers, `-d` for the request body.

This was meant as a learning project on bash scripting and basic automation, not a production tool.

## Requirements

- bash
- curl
- A local backend running on `https://localhost:<port>/<api>/<endpoint>`

## Usage

```bash
chmod +x script.sh
./script.sh
```

Follow the prompts:
- API name and port (only asked when you choose to set/change them).
- Endpoint name (without a leading `/`).
- HTTP method (leave empty for GET).
- If the method isn't GET, enter `key value` pairs one at a time; press Enter with an empty key to finish and send the request.

## Example flow

```
You wanna change the api or the port? y
Introduce a APIs name: users
Introduce a PORT: 3000
the endpoint must not start with /
Introduce a Endpoit name: create
Introduce a method: POST
Introduce key value: name Carlos
Introduce key value: age 29
Introduce key value:
```

This builds and runs something equivalent to:

```bash
curl -X POST "https://localhost:3000/users/create" -H "Content-Type: application/json" -d '{name:Carlos,age:29}'
```

## Notes / limitations

- This is a learning project — the JSON body building is basic (it doesn't quote string values or distinguish numbers/booleans/strings).
- No support for custom headers beyond `Content-Type: application/json`.
- No support for nested JSON objects or arrays as values.
- Assumes `https://localhost` as the base URL.

## Next steps (ideas for improvement)

- Proper JSON value typing (strings vs numbers vs booleans).
- Support for custom headers.
- Support for other base URLs, not just `localhost`.
- Save frequently used requests for reuse.