let canvas = document.getElementById("progress").getContext('2d');
let playtag = document.getElementById('playing')
let nowPlaying = document.getElementById('1');

function updatePlaying(id) {
  nowPlaying = document.getElementById(id);
}

function clearCanvas() {
  canvas.fillStyle = "#000000";
  canvas.fillRect(0,0,1000,25)
}
		
function updateBar(element) {
  let audio = element;
  let currentTime = audio.currentTime;
  let duration = audio.duration;
  let progress = (1000 * (currentTime / duration));
  canvas.fillStyle = "#00FF00";
  canvas.fillRect(0,0,progress,25);
}

function playNext(element) {
  newid = document.getElementById(parseInt(element.id) + 1);
  if (newid === null) {
    newid = document.getElementById(1);
  }
  newid.play();
  updatePlaying(newid.id);
  playtag.innerHTML = "Now playing: " + newid;
  window.setTimeout(clearCanvas,50);
}

function play(element) {
  clearCanvas();
  let id = element.id.substring(1);
  nowPlaying.pause();
  updatePlaying(id);
  document.getElementById(id).play();
  playtag.innerHTML = "Now playing: " + id;
  window.setTimeout(clearCanvas,50);
}
		
function stop(element) {
  clearCanvas();
  let id = element.id.substring(1);
  document.getElementById(id).pause();
  playtag.innerHTML = "Now playing: none";
  window.setTimeout(clearCanvas,50);
}
