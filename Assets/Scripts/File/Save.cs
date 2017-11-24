using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

[Serializable]
public class Save
{
    [Serializable]
    public class Item
    {
        public Item(string _key, object _value)
        {
            key = _key;
            value = _value;
        }

        public string key;
        public object value;
    }

    public int version = 0;
    public List<Item> items = new List<Item>();
}
