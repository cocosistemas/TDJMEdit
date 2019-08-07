program TestDJMEditBerlin;

uses
  Vcl.Forms,
  fTestDJMEdit in 'fTestDJMEdit.pas' {frTestDJMEdit},
  uTDJMEdit in '..\uTDJMEdit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrTestDJMEdit, frTestDJMEdit);
  Application.Run;
end.
