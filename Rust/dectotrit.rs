fn trit(num: i128) {
    let mut v: Vec<char> = Vec::new();
    let mut cnt = num;
    
    loop {
    
        let mut tmp = cnt % 3;
        cnt /= 3;
    
        if tmp == 2 { 
            tmp = -1; 
            cnt += 1; 
        
        } else if tmp == -2 {
            tmp =  1;
            cnt -= 1; 
        
        };
    
        match tmp {
            1  => v.push('+'),
            -1 => v.push('-'),
            _  => v.push('='),
        };
    
        if cnt == 0 { 
            v.reverse();
            let s: String = v.iter().collect();
            println!("{s}");
            break;
        
        };
    }
}