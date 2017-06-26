package commands;

/**
 * Created by sinakashipazha on 2017/6/26 AD.
 */
public interface Command {
    String getDescription();

    Result _do();
}
