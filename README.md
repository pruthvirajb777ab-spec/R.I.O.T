
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Kaushal | Engineering Portfolio</title>

<link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,400;0,500;0,600;1,400;1,500&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">

<style>
*{box-sizing:border-box;margin:0;padding:0}
body{background:#f5f4ef;color:#20231f;font-family:'DM Sans',sans-serif}
header{display:flex;justify-content:space-between;align-items:center;padding:22px 7%;border-bottom:1px solid #dddcd3}
.logo{font:600 34px 'Cormorant Garamond',serif}
nav{display:flex;gap:22px}
nav a{font-size:12px;color:#666;text-decoration:none}
.hero{padding:90px 7%;border-bottom:1px solid #dddcd3}
.label{font-size:10px;letter-spacing:3px;color:#777;text-transform:uppercase}
h1{font:400 clamp(55px,9vw,105px)/.95 'Cormorant Garamond',serif;margin:25px 0;letter-spacing:-2px}
h1 em,h2 em{color:#405b49}
.hero p{font-size:13px;line-height:2;color:#777;max-width:450px;margin-bottom:25px}
.btn{display:inline-block;background:#20231f;color:white;border:1px solid #20231f;padding:13px 18px;font-size:11px;cursor:pointer;text-decoration:none}
main{padding:55px 7%}
.section-head{display:flex;align-items:end;justify-content:space-between;gap:15px;margin-bottom:25px}
h2{font:500 44px 'Cormorant Garamond',serif;margin-top:8px}
.projects{display:grid;grid-template-columns:repeat(3,1fr);gap:15px}
.card{padding:24px;border:1px solid #dddcd3;background:#fffefa;min-height:215px;display:flex;flex-direction:column}
.card h3{font:500 30px 'Cormorant Garamond',serif;margin:30px 0 10px}
.card p{font-size:12px;color:#777;line-height:1.8}
.card small{font-size:10px;color:#777}
.card button{align-self:flex-start;margin-top:auto}
.section{margin-bottom:70px}
input,select,textarea{padding:12px;border:1px solid #dddcd3;background:transparent;font:12px 'DM Sans',sans-serif;min-width:0}
.vault{padding:25px;border:1px solid #dddcd3;background:#fffefa}
.tools{display:flex;gap:10px;margin:25px 0;flex-wrap:wrap}
#search{flex:1}
.file{display:grid;grid-template-columns:45px 1fr auto;gap:12px;align-items:center;padding:16px 0;border-top:1px solid #dddcd3}
.file-icon{padding:14px 5px;background:#efeee8;text-align:center;font:12px 'Cormorant Garamond',serif}
.file-name{font-size:12px;overflow-wrap:anywhere}
.meta{font-size:10px;color:#777;margin-top:5px}
.actions{display:flex;gap:5px;flex-wrap:wrap}
.actions button{background:transparent;border:1px solid #dddcd3;padding:8px;font-size:10px;cursor:pointer}
.upload{padding:30px 10px;text-align:center;border:1px dashed #aaa;margin-top:20px}
.upload h3{font:500 28px 'Cormorant Garamond',serif}
.upload p{font-size:11px;color:#777;margin:10px}
.empty{text-align:center;padding:35px;color:#777;font-size:12px}
.about{padding-top:30px;border-top:1px solid #dddcd3;display:grid;grid-template-columns:1fr 1fr;gap:35px}
.about p{font-size:12px;color:#777;line-height:2;margin-bottom:15px}
footer{padding:25px 7%;border-top:1px solid #dddcd3;color:#777;font-size:10px;display:flex;justify-content:space-between}
dialog{padding:25px;width:min(430px,94%);margin:auto;border:1px solid #dddcd3;background:#fffefa}
dialog::backdrop{background:#0008}
dialog h2{font-size:35px;margin-bottom:20px}
.field{margin:14px 0}
.field label{display:block;font-size:10px;color:#777;margin-bottom:7px}
.field input,.field textarea,.field select{width:100%}
@media(max-width:700px){
 header{padding:18px 5%}nav{gap:10px}nav a{font-size:10px}
 .hero{padding:65px 5%}main{padding:40px 5%}
 .projects{grid-template-columns:1fr}
 .file{grid-template-columns:38px 1fr}.actions{grid-column:2}
 .about{grid-template-columns:1fr}
 footer{padding:20px 5%;gap:10px;flex-wrap:wrap}
}
</style>
</head>
<body>

<header>
<div class="logo">K.</div>
<nav>
<a href="#projects">Projects</a>
<a href="#vault">Documents</a>
<a href="#about">About</a>
</nav>
</header>

<section class="hero">
<div class="label">Computer Science Engineering · 2026</div>
<h1>Building ideas.<br><em>Making them real.</em></h1>
<p>A premium digital portfolio documenting my engineering journey, projects, research, presentations and creative experiments.</p>
<a class="btn" href="#projects">EXPLORE MY WORK ↗</a>
</section>

<main>
<section class="section" id="projects">
<div class="section-head">
<div><div class="label">01 / Selected work</div><h2>My projects.</h2></div>
<button class="btn" onclick="document.getElementById('projectDialog').showModal()">+ NEW PROJECT</button>
</div>
<div class="projects" id="projectsList"></div>
</section>

<section class="section" id="vault">
<div class="label">02 / Digital archive</div>
<h2>Document vault.</h2>
<p style="font-size:12px;color:#777;margin-top:10px">Upload, search and organise your project files in one place.</p>
<div class="vault" style="margin-top:25px">
<div class="tools">
<input id="search" placeholder="Search documents..." oninput="renderFiles()">
<select id="projectSelect" onchange="renderFiles()"><option value="">All projects</option></select>
<button class="btn" onclick="document.getElementById('fileInput').click()">UPLOAD FILES +</button>
<input type="file" id="fileInput" multiple hidden onchange="uploadFiles(event)">
</div>
<div id="fileList"></div>
<div class="upload">
<h3>Your work, organised.</h3>
<p>PDF · DOCX · PPTX · XLSX · Images · Text files</p>
<button class="btn" onclick="document.getElementById('fileInput').click()">CHOOSE DOCUMENTS ↗</button>
</div>
<p class="meta" style="margin-top:15px">Local browser storage only. This does not share documents online between users.</p>
</div>
</section>

<section class="about section" id="about">
<div><div class="label">03 / About me</div><h2>Curious by nature.<br><em>Engineer in progress.</em></h2></div>
<div><p>I am a first-year Computer Science Engineering student focused on learning through practical projects, technology and collaboration.</p><p>This portfolio is my growing archive of ideas, skills, research and achievements.</p><p><strong>INTERESTS</strong><br>Programming · Web Development · AI · Innovation</p></div>
</section>
</main>

<footer><span>© 2026 KAUSHAL · PORTFOLIO</span><span>DESIGNED WITH PURPOSE.</span></footer>

<dialog id="projectDialog">
<form id="projectForm">
<h2>Create project.</h2>
<div class="field"><label>PROJECT NAME</label><input name="name" required placeholder="Smart Attendance System"></div>
<div class="field"><label>DESCRIPTION</label><textarea name="description" rows="3"></textarea></div>
<div style="display:flex;gap:10px;justify-content:flex-end;margin-top:20px">
<button type="button" class="btn" onclick="document.getElementById('projectDialog').close()">CANCEL</button>
<button class="btn">SAVE</button>
</div>
</form>
</dialog>

<script>
let projects=[];
let files=[];

function makeId(){
 return Date.now().toString(36)+Math.random().toString(36).slice(2);
}

function load(){
 try{
  projects=JSON.parse(localStorage.getItem('portfolioProjects')||'[]');
  files=JSON.parse(localStorage.getItem('portfolioFiles')||'[]');
 }catch(e){projects=[];files=[];}
 renderProjects();
 renderFiles();
}

function save(){
 localStorage.setItem('portfolioProjects',JSON.stringify(projects));
 localStorage.setItem('portfolioFiles',JSON.stringify(files));
}

function safe(s){
 return String(s||'').replace(/[&<>"']/g,c=>({
  '&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#39;'
 }[c]));
}

function renderProjects(){
 const list=document.getElementById('projectsList');
 list.innerHTML='';
 projects.forEach((p,i)=>{
  const card=document.createElement('article');
  card.className='card';
  card.innerHTML=`<small>PROJECT / ${String(i+1).padStart(2,'0')}</small>
  <h3>${safe(p.name)}</h3><p>${safe(p.description||'An idea in development.')}</p>
  <button class="btn" style="margin-top:20px" data-filter="${p.id}">VIEW DOCUMENTS</button>
  <button data-delete="${p.id}" style="border:0;background:none;color:#777;font-size:10px;margin-top:12px">Delete project</button>`;
  list.appendChild(card);
 });
 const add=document.createElement('button');
 add.className='card';
 add.style.cssText='cursor:pointer;text-align:center;justify-content:center';
 add.textContent='+ CREATE A PROJECT';
 add.onclick=()=>document.getElementById('projectDialog').showModal();
 list.appendChild(add);

 list.querySelectorAll('[data-filter]').forEach(b=>b.onclick=()=>{
  document.getElementById('projectSelect').value=b.dataset.filter;
  document.getElementById('vault').scrollIntoView({behavior:'smooth'});
  renderFiles();
 });
 list.querySelectorAll('[data-delete]').forEach(b=>b.onclick=()=>{
  if(confirm('Delete this project?')){
   projects=projects.filter(p=>p.id!==b.dataset.delete);
   save();renderProjects();renderFiles();
  }
 });
 document.getElementById('projectSelect').innerHTML=
 '<option value="">All projects</option>'+projects.map(p=>`<option value="${p.id}">${safe(p.name)}</option>`).join('');
}

document.getElementById('projectForm').onsubmit=e=>{
 e.preventDefault();
 const d=new FormData(e.target);
 projects.push({id:makeId(),name:d.get('name'),description:d.get('description')});
 save();renderProjects();renderFiles();
 document.getElementById('projectDialog').close();
 e.target.reset();
};

function uploadFiles(e){
 const selected=Array.from(e.target.files);
 selected.forEach(f=>{
  const reader=new FileReader();
  reader.onload=()=>{
   files.push({id:makeId(),name:f.name,size:f.size,data:reader.result,project:'',type:f.type});
   try{save();renderFiles();}
   catch(err){alert('Storage limit reached. Use cloud storage for larger files.');}
  };
  reader.readAsDataURL(f);
 });
 e.target.value='';
}

function renderFiles(){
 const q=document.getElementById('search').value.toLowerCase();
 const project=document.getElementById('projectSelect').value;
 const shown=files.filter(f=>
  f.name.toLowerCase().includes(q)&&(!project||f.project===project)
 );
 const list=document.getElementById('fileList');
 list.innerHTML='';
 if(!shown.length){
  list.innerHTML='<div class="empty">No documents found.<br>Upload your first project file.</div>';
  return;
 }
 shown.forEach(f=>{
  const p=projects.find(p=>p.id===f.project);
  const row=document.createElement('div');
  row.className='file';
  const extension=f.name.split('.').pop().toUpperCase().slice(0,5);
  row.innerHTML=`<div class="file-icon">${safe(extension)}</div>
  <div><div class="file-name">${safe(f.name)}</div>
  <div class="meta">${(f.size/1024).toFixed(1)} KB · ${safe(p?p.name:'Unassigned')}</div></div>
  <div class="actions"><button data-download="${f.id}">DOWNLOAD</button><button data-assign="${f.id}">ASSIGN</button><button data-remove="${f.id}">DELETE</button></div>`;
  list.appendChild(row);
 });
 list.querySelectorAll('[data-download]').forEach(b=>b.onclick=()=>{
  const f=files.find(f=>f.id===b.dataset.download);
  const a=document.createElement('a');a.href=f.data;a.download=f.name;a.click();
 });
 list.querySelectorAll('[data-remove]').forEach(b=>b.onclick=()=>{
  if(confirm('Delete this file?')){
   files=files.filter(f=>f.id!==b.dataset.remove);
   save();renderFiles();
  }
 });
 list.querySelectorAll('[data-assign]').forEach(b=>b.onclick=()=>{
  const f=files.find(f=>f.id===b.dataset.assign);
  const choices=projects.map((p,i)=>`${i+1}. ${p.name}`).join('\n');
  if(!projects.length){alert('Create a project first.');return;}
  const answer=prompt('Enter project number:\n'+choices);
  const p=projects[Number(answer)-1];
  if(p){f.project=p.id;save();renderFiles();}
 });
}

load();
</script>
</body>
</html>

