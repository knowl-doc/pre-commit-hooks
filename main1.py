import typer

# This is a sample Python script.

# Press ⌃R to execute it or replace it with your code.
# Press Double ⇧ to search everywhere for classes, files, tool windows, actions, and settings.

app = typer.Typer()


@app.command()
def review_linked_updated_snippets():
    # argument - code line information
    # logic -
    # show all the files in a list. Actions- all files reviewed.
    # show actions help - enter r for reviewed,  nr for not reviewed.
    # If nr then exit the commit
    print("here is list of knowl pages (with links) & snippets that are linked with code lines and are updated")


@app.command()
def review_linked_not_updated_snippets():
    # argument - code line information
    # logic
    # show each file one by one
    # show actions help - enter u for updated, nu for no update required, lu for later update
    print("here is list of knowl pages with links & snippets that are linked with code lines and are not updated")


# Press the green button in the gutter to run the script.
if __name__ == '__main__':
    app()
