import gdb
import subprocess
class WaitProcess (gdb.Command):
  "Wait until a process with the given name starts up and attach to it."

  def __init__ (self):
      super (WaitProcess, self).__init__ ("waitprocess",
                         gdb.COMMAND_SUPPORT,
                         gdb.COMPLETE_NONE, False)
  def invoke(self, arg, from_tty):
      while True:
        try:
            pid = int(subprocess.check_output(["pidof", arg]))
            break
        except subprocess.CalledProcessError:
            continue
      gdb.execute("attach " + str(pid))
      # gdb.execute("continue") 
WaitProcess()

