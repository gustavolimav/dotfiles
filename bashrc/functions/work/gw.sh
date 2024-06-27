function compileJava() {
    gw compileJava
    gw compileTestJava
}

function deploy() {
    gw deploy
}

function beforePR() {
    compileJava
    deploy
}