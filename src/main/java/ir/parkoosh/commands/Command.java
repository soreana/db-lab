package ir.parkoosh.commands;

/**
 * Created by sinakashipazha on 2017/6/26 AD.
 */
public interface Command {
    String getDescription();

    default Result _do(){
        try { return __do();}
        catch (Exception e) { e.printStackTrace();}
        return null;
    }

    Result __do() throws Exception;
}
