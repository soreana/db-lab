import commands.Command;
import commands.ShowPlayers;
import commands.ShowTeamInfo;

import java.util.ArrayList;
import java.util.Scanner;

/**
 * Created by sinakashipazha on 2017/6/26 AD.
 */
public class Main {
    private static Command [] commands;
    private static String teamName ;

    static {
        ArrayList<Command> temp = new ArrayList<>();
        temp.add(new ShowPlayers());
        temp.add(new ShowTeamInfo());

        commands = (Command[]) temp.toArray();
    }

    private static void showIntroductionMessage(){
        System.out.println("Hi :)");
        System.out.println("I'm your private agent.");
        System.out.println("I can help you to manage your team.");
    }

    public static String getTeamName(){
        return teamName;
    }

    public static void main(String [] args){
        showIntroductionMessage();
        Scanner console = new Scanner(System.in);
        int commandNumber = 0;

        teamName = console.next();

        while (true) {
            System.out.println("What is your command:");
            for (int i = 0; i < commands.length; i++)
                System.out.println(i + ". " + commands[i].getDescription());

            System.out.println(commands.length + ". exit" );

            commandNumber = console.nextInt();

            if (commandNumber == commands.length)
                break;

            commands[commandNumber]._do();
        }
    }
}
