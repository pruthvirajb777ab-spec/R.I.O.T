<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Animation Pad</title>

<style>
* {
    box-sizing: border-box;
    margin: 0;
    padding: 0;
}

body {
    font-family: Arial, sans-serif;
    background: #0b0b0f;
    color: white;
    min-height: 100vh;
}

header {
    height: 65px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 0 20px;
    background: #141419;
    border-bottom: 1px solid #292932;
}

.logo {
    font-size: 22px;
    font-weight: bold;
}

.logo span {
    color: #6c63ff;
}

button {
    border: none;
    border-radius: 10px;
    padding: 10px 16px;
    background: #24242d;
    color: white;
    cursor: pointer;
    font-weight: bold;
}

button:hover {
    background: #343440;
}

.generate {
    background: #6c63ff;
}

.generate:hover {
    background: #574fe0;
}

.app {
    display: flex;
    min-height: calc(100vh - 65px);
}

.sidebar {
    width: 270px;
    background: #111116;
    padding: 18px;
    border-right: 1px solid #292932;
}

.sidebar h3 {
    margin-bottom: 12px;
}

textarea {
    width: 100%;
    height: 130px;
    resize: none;
    background: #1b1b22;
    border: 1px solid #30303a;
    color: white;
    border-radius: 12px;
    padding: 12px;
    outline: none;
    font-size: 14px;
}

.generate {
    width: 100%;
    margin-top: 10px;
}

.controls {
    margin-top: 25px;
}

.controls label {
    display: block;
    margin: 15px 0 7px;
    font-size: 13px;
    color: #aaa;
}

input[type="range"] {
    width: 100%;
}

select {
    width: 100%;
    padding: 10px;
    background: #1b1b22;
    color: white;
    border: 1px solid #30303a;
    border-radius: 8px;
}

.workspace {
    flex: 1;
    display: flex;
    flex-direction: column;
}

.canvas-area {
    flex: 1;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 20px;
}

canvas {
    width: min(90vw, 900px);
    height: min(65vh, 550px);
    background: #202027;
    border-radius: 15px;
    border: 2px solid #33333d;
    box-shadow: 0 10px 40px rgba(0,0,0,.4);
}

.timeline {
    height: 125px;
    background: #121218;
    border-top: 1px solid #292932;
    padding: 12px;
}

.timeline-top {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 10px;
}

.frames {
    display: flex;
    gap: 7px;
    overflow-x: auto;
}

.frame {
    min-width: 55px;
    height: 55px;
    background: #24242d;
    border: 2px solid transparent;
    border-radius: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    cursor: pointer;
    font-size: 12px;
}

.frame.active {
    border-color: #6c63ff;
}

.status {
    font-size: 12px;
    color: #aaa;
    margin-top: 8px;
}

@media(max-width: 700px) {
    .sidebar {
        width: 210px;
    }

    header {
        padding: 0 10px;
    }

    .logo {
        font-size: 18px;
    }
}
</style>
</head>

<body>

<header>
    <div class="logo">Animation <span>Pad</span></div>

    <div>
        <button onclick="newProject()">New</button>
        <button onclick="downloadAnimation()">Export</button>
    </div>
</header>

<div class="app">

    <aside class="sidebar">

        <h3>✨ AI Animation</h3>

        <textarea id="prompt"
        placeholder="Describe your animation...

Example:
A red ball bouncing on the ground"></textarea>

        <button class="generate" onclick="generateAnimation()">
            Generate Animation
        </button>

        <div class="controls">

            <label>Animation Type</label>

            <select id="animationType">
                <option value="auto">Auto</option>
                <option value="bounce">Bouncing</option>
                <option value="move">Moving</option>
                <option value="rotate">Rotating</option>
                <option value="scale">Growing</option>
                <option value="orbit">Orbit</option>
            </select>

            <label>Speed</label>
            <input type="range" id="speed" min="0.2" max="3" value="1" step="0.1">

            <label>Background</label>
            <select id="background">
                <option value="dark">Dark</option>
                <option value="space">Space</option>
                <option value="sky">Sky</option>
                <option value="white">White</option>
            </select>

        </div>

        <div class="status" id="status">
            Ready — describe your animation.
        </div>

    </aside>

    <main class="workspace">

        <div class="canvas-area">
            <canvas id="canvas" width="900" height="550"></canvas>
        </div>

        <div class="timeline">

            <div class="timeline-top">
                <button onclick="togglePlay()" id="playBtn">▶ Play</button>
                <button onclick="previousFrame()">◀</button>
                <button onclick="nextFrame()">▶</button>

                <span id="frameText">Frame 1 / 60</span>
            </div>

            <div class="frames" id="frames"></div>

        </div>

    </main>

</div>

<script>

const canvas = document.getElementById("canvas");
const ctx = canvas.getContext("2d");

let playing = false;
let frame = 0;
let animationType = "bounce";
let speed = 1;
let animationId;

const totalFrames = 60;

function createTimeline() {

    const frames = document.getElementById("frames");
    frames.innerHTML = "";

    for(let i = 0; i < totalFrames; i++) {

        const div = document.createElement("div");

        div.className = "frame";
        div.innerText = i + 1;

        div.onclick = () => {
            frame = i;
            draw();
        };

        frames.appendChild(div);
    }

    updateTimeline();
}

function updateTimeline() {

    document.getElementById("frameText").innerText =
        "Frame " + (frame + 1) + " / " + totalFrames;

    document.querySelectorAll(".frame").forEach((el, i) => {
        el.classList.toggle("active", i === frame);
    });
}

function getBackground() {

    const bg = document.getElementById("background").value;

    if(bg === "space") {
        ctx.fillStyle = "#05051b";
    }
    else if(bg === "sky") {
        ctx.fillStyle = "#79c7ff";
    }
    else if(bg === "white") {
        ctx.fillStyle = "#eeeeee";
    }
    else {
        ctx.fillStyle = "#202027";
    }

    ctx.fillRect(0,0,canvas.width,canvas.height);
}

function drawGrid() {

    ctx.strokeStyle = "rgba(255,255,255,.06)";
    ctx.lineWidth = 1;

    for(let x=0;x<canvas.width;x+=50) {
        ctx.beginPath();
        ctx.moveTo(x,0);
        ctx.lineTo(x,canvas.height);
        ctx.stroke();
    }

    for(let y=0;y<canvas.height;y+=50) {
        ctx.beginPath();
        ctx.moveTo(0,y);
        ctx.lineTo(canvas.width,y);
        ctx.stroke();
    }
}

function drawGround() {

    ctx.fillStyle = "#303038";

    ctx.fillRect(
        0,
        canvas.height - 70,
        canvas.width,
        70
    );

    ctx.fillStyle = "#4b4b55";

    ctx.fillRect(
        0,
        canvas.height - 70,
        canvas.width,
        4
    );
}

function drawBall(x,y,size,color) {

    const gradient = ctx.createRadialGradient(
        x-size*.3,
        y-size*.3,
        2,
        x,
        y,
        size
    );

    gradient.addColorStop(0,"#ffffff");
    gradient.addColorStop(.15,color);
    gradient.addColorStop(1,"#111111");

    ctx.fillStyle = gradient;

    ctx.beginPath();
    ctx.arc(x,y,size,0,Math.PI*2);
    ctx.fill();

    ctx.strokeStyle = "rgba(255,255,255,.4)";
    ctx.stroke();
}

function draw() {

    getBackground();

    drawGrid();

    drawGround();

    const t = frame / totalFrames * Math.PI * 2;

    let x = canvas.width / 2;
    let y = canvas.height - 120;
    let size = 45;
    let rotation = 0;

    const prompt =
        document.getElementById("prompt").value.toLowerCase();

    let color = "#ff3030";

    if(prompt.includes("blue"))
        color = "#298cff";

    if(prompt.includes("green"))
        color = "#24d66b";

    if(prompt.includes("yellow"))
        color = "#ffd32a";

    if(prompt.includes("purple"))
        color = "#a855f7";

    if(prompt.includes("orange"))
        color = "#ff8c32";

    if(animationType === "bounce") {

        let bounce = Math.abs(Math.sin(t * 2));

        y = canvas.height - 120 - bounce * 250;
    }

    else if(animationType === "move") {

        x = 100 + ((frame / totalFrames) * 700);

    }

    else if(animationType === "rotate") {

        rotation = t;
    }

    else if(animationType === "scale") {

        size = 25 + Math.abs(Math.sin(t)) * 55;
    }

    else if(animationType === "orbit") {

        x = canvas.width/2 + Math.cos(t) * 220;
        y = canvas.height/2 + Math.sin(t) * 150;
    }

    ctx.save();

    ctx.translate(x,y);
    ctx.rotate(rotation);

    drawBall(0,0,size,color);

    ctx.restore();

    updateTimeline();
}

function generateAnimation() {

    const prompt =
        document.getElementById("prompt").value.toLowerCase();

    if(prompt.includes("bounce") ||
       prompt.includes("jump")) {

        animationType = "bounce";
        document.getElementById("animationType").value = "bounce";
    }

    else if(prompt.includes("move") ||
            prompt.includes("run") ||
            prompt.includes("walk")) {

        animationType = "move";
        document.getElementById("animationType").value = "move";
    }

    else if(prompt.includes("rotate") ||
            prompt.includes("spin")) {

        animationType = "rotate";
        document.getElementById("animationType").value = "rotate";
    }

    else if(prompt.includes("grow") ||
            prompt.includes("big")) {

        animationType = "scale";
        document.getElementById("animationType").value = "scale";
    }

    else if(prompt.includes("orbit") ||
            prompt.includes("circle")) {

        animationType = "orbit";
        document.getElementById("animationType").value = "orbit";
    }

    else {
        animationType = document.getElementById("animationType").value;

        if(animationType === "auto")
            animationType = "bounce";
    }

    frame = 0;

    document.getElementById("status").innerText =
        "Animation generated from your description.";

    draw();
}

function togglePlay() {

    playing = !playing;

    document.getElementById("playBtn").innerText =
        playing ? "⏸ Pause" : "▶ Play";

    if(playing)
        animate();
}

function animate() {

    if(!playing)
        return;

    frame += 1;

    if(frame >= totalFrames)
        frame = 0;

    draw();

    const speedValue =
        Number(document.getElementById("speed").value);

    animationId =
        setTimeout(() => requestAnimationFrame(animate),
        50 / speedValue);
}

function previousFrame() {

    frame--;

    if(frame < 0)
        frame = totalFrames - 1;

    draw();
}

function nextFrame() {

    frame++;

    if(frame >= totalFrames)
        frame = 0;

    draw();
}

document.getElementById("speed").addEventListener("input", e => {
    speed = Number(e.target.value);
});

document.getElementById("animationType").addEventListener("change", e => {

    animationType = e.target.value;

    if(animationType === "auto")
        animationType = "bounce";

    draw();
});

document.getElementById("background").addEventListener("change", draw);

function newProject() {

    playing = false;
    frame = 0;

    document.getElementById("prompt").value = "";

    document.getElementById("status").innerText =
        "New project created.";

    document.getElementById("playBtn").innerText = "▶ Play";

    draw();
}

function downloadAnimation() {

    const link = document.createElement("a");

    link.download = "animation-pad-frame.png";

    link.href = canvas.toDataURL("image/png");

    link.click();

    document.getElementById("status").innerText =
        "Current animation frame exported.";
}

createTimeline();
draw();

</script>

</body>
</html>
