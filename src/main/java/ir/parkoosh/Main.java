package ir.parkoosh;

import ir.parkoosh.commands.Command;
import ir.parkoosh.commands.ShowPlayers;
import ir.parkoosh.commands.ShowTeamInfo;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Scanner;

/**
 * Created by sinakashipazha on 2017/6/26 AD.
 */
public class Main {
    private static Command [] commands;
    private static String teamName ;
    private static Connection connection;

    static {
        ArrayList<Command> temp = new ArrayList<>();
        temp.add(new ShowPlayers());
        temp.add(new ShowTeamInfo());

        commands = temp.toArray(new Command[temp.size()]);
    }

    private static void showIntroductionMessage(){
        System.out.println("Hi :)");
        System.out.println("I'm your private agent.");
        System.out.println("I can help you to manage your team.");
        System.out.println("Enter your team ID");
    }

    public static String getTeamID(){
        return teamName;
    }

    public static Connection getConnection() {
        return connection;
    }

    private static void initialSetups(){
        try {
            Class.forName("org.postgresql.Driver");

            String url      = "jdbc:postgresql://82.102.10.91:5432/mydb";   //database specific url.
            String user     = "asa";
            String password = "123";

            connection = DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException ignored) {}
        catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String [] args){
        showIntroductionMessage();
        Scanner console = new Scanner(System.in);
        int commandNumber = 0;

        initialSetups();

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
