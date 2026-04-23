package org.example;

import com.opencsv.CSVReader;
import com.opencsv.exceptions.CsvException;

import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Main {

    static List<Actor> actor_list = new ArrayList<>() ;

    public static void main(String[] args) {

        var myDate = new Date(18,11,1402);
        System.out.println(myDate.nextDay());

        add_actors(data_reader("src/main/input.csv"));
        count_days_starring("James Stewart");

    }

    public static void count_days_starring(String actor_name){
        int total_days = 0 ;
        Actor actor = actor_list.stream()
                .filter(item -> item.name.equals(actor_name)).toList().getFirst();
        for (Starring movieItem: actor.starring_list)
            total_days += actor.get_total_days(movieItem.movie);
        System.out.println(total_days);
    }

    public static void add_actors(List<String[]> data){
        for (String[] starring : data){
            Actor actor = find_actor(starring[0]);
            actor.add_starring(create_starring(starring));
        }
    }

    public static Starring create_starring(String[] starring){
        List<Integer> numbers = Arrays.stream(starring, 2, starring.length)
                .map(Integer::parseInt).toList();
        Date start = new Date(numbers.get(0), numbers.get(1), numbers.get(2));
        Date end = new Date(numbers.get(3),numbers.get(4),numbers.get(5));
        return (new Starring(starring[1], start, end));
    }

    public static Actor find_actor(String actor_name){
        List<Actor> search_result = actor_list.stream()
                .filter(item -> item.name.equals(actor_name)).toList();

        if (search_result.isEmpty()) {
            Actor actor = new Actor(actor_name);
            actor_list.add(actor);
            return actor;
        }

        return search_result.getFirst() ;
    }

    public static List<String[]> data_reader(String address){
        List<String[]> rows = null ;

        try (CSVReader reader = new CSVReader(new FileReader(address))) {
            rows = reader.readAll();
        } catch (IOException | CsvException e) {
            System.out.println(e.getMessage());
        }

        return rows ;
    }
}