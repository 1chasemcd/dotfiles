let colon = ""

function setTime() {
    let date = new Date();
    let hour = date.getHours();
    hour = hour % 12;

    let min = date.getMinutes();
    min = String(min);

    if (min.length == 1) {
        min = "0" + min;
    }

    if (colon == ":") {
        colon = " ";
    } else {
        colon = ":";
    }

    document.getElementById("clock").innerHTML = hour + colon + min;
}

setInterval(setTime, 1000);

setTime();

let shortcuts = {}

for (let separator of document.getElementById("launcher-container").children) {
    for (let a of separator.children) {

        text = a.innerHTML

        for (let index in text) {
            if (!shortcuts.hasOwnProperty(text[index]) && text[index] != " ") {
                shortcuts[text[index]] = a.href;
                text = text.substring(0, index) + "<b>" + text[index] + "</b>" + text.substring(parseInt(index) + 1);
                a.innerHTML = text;
                break;
            }
        }
    }
}

document.addEventListener("keydown", function(e) {
    for (let shortcut in shortcuts) {
        if (e.key == shortcut) {
            window.open(shortcuts[shortcut], "_self")
        }
    }
})