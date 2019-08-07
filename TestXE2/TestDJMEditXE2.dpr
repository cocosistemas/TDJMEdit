program TestDJMEditXE2;

uses
  Vcl.Forms,
  uTDJMEdit in '..\uTDJMEdit.pas',
  fTestDJMEdit in 'fTestDJMEdit.pas' {frTestDJMEdit};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrTestDJMEdit, frTestDJMEdit);
  Application.Run;
end.
