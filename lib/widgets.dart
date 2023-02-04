import 'package:flutter/material.dart';

Widget CoinListViewHeader(context, count) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * 0.08,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(
                Icons.pie_chart_outline_rounded,
                color: Colors.amberAccent,
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Show Chart",
                  style: TextStyle(color: Colors.amberAccent),
                ),
              ),
            ],
          ),
          Text(
            "Count: $count",
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ],
      ),
    ),
  );
}

Widget CoinListView(context, res) {
  Map<String, dynamic> coins = res["data"];
  int noOfCoins = coins.length;

  return Column(
    children: [
      CoinListViewHeader(context, noOfCoins),
      Expanded(
        child: ListView.builder(
          itemCount: noOfCoins,
          itemBuilder: (context, index) {
            String coin = coins.keys.elementAt(index);
            Map<String, dynamic> coinData = coins[coin];

            String name = coinData["name"];
            double price = double.parse(
                coinData["quote"]["USD"]["price"].toStringAsFixed(2));
            int rank = coinData["cmc_rank"];
            double change = double.parse(coinData["quote"]["USD"]
                    ["percent_change_24h"]
                .toStringAsFixed(2));
            Icon changeIcon = (change > 0
                ? const Icon(
                    Icons.arrow_upward_rounded,
                    color: Colors.green,
                  )
                : const Icon(
                    Icons.arrow_downward_rounded,
                    color: Colors.red,
                  ));

            return Container(
              margin: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.all(8.0),
              decoration: const BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: ListTile(
                title: Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  changeIcon,
                                  Text(
                                    "${change.abs()}%",
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                ],
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.24,
                                padding: const EdgeInsets.all(2),
                                decoration: const BoxDecoration(
                                  color: Colors.white24,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4)),
                                ),
                                child: Center(
                                  child: Text(
                                    coin,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                              )
                            ]),
                      )
                    ],
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Price: \$ $price",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Rank: $rank",
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          Container(
                            width: 36.0,
                            height: 36.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.yellow[600],
                            ),
                            child: const Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    ],
  );
}
