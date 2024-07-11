function compileJava() {
  emulate -LR bash
    gw compileJava
    gw compileTestJava
}

function deploy() {
  emulate -LR bash
    gw deploy
}

function beforePR() {
  emulate -LR bash
    compileJava
    deploy
}