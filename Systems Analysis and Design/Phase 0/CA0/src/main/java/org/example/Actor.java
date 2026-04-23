package org.example;

import java.util.ArrayList;
import java.util.stream.Stream;

public class Actor {
    public String name;
    public ArrayList<Starring> starring_list = new ArrayList<>();

    Actor(String _name) {
        name = _name;
    }

    public void add_starring(Starring starring){

        for (Starring item : starring_list){
            if (item.intersection(starring))
                return;
        }

        starring_list.add(starring);
    }

    public int get_total_days(String movie_name){
        return starring_list.stream().filter(item -> movie_name.equals(item.movie)).toList().getFirst().count_days() ;
    }
}
