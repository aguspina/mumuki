function setAceEditor() {
  var textarea = document.getElementById("editor");
  var form = textarea.form;

  var editor = ace.edit(textarea);
  editor.getSession().setUseWorker(false);
  var language = $(":selected").html();
  changeEditorLanguage(language);
  editor.container.id = "editor-container";

  form.addEventListener("submit", function() {
    textarea.style.visibility = "hidden";
    textarea.value = editor.getValue();
    form.appendChild(textarea);
  });
}

function onSelectChange() {
  $("#exercise_language_id").change(function() {
    language = $(":selected").html();
    changeEditorLanguage(language);
  });
}

function changeEditorLanguage(language) {
  if(language !== undefined) {
    editor.getSession().setMode("ace/mode/"+language.toLowerCase());
  }
}


$(document).ready(function() {
  setAceEditor();
  onSelectChange();
});
