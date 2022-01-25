function red() {
    echo -ne "\x1B[31m"
}
function green() {
    echo -ne "\x1B[32m"
}
function blue() {
    echo -ne "\x1B[34m"
}
function yellow() {
    echo -ne "\x1B[33m"
}
function bold() {
    echo -ne "\x1B[1m"
}
function blink() {
    echo  -ne "\033[5m"
}
function reset() {
    echo -ne "\x1B[0m"
}
