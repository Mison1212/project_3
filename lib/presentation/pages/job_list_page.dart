import 'package:flutter/material.dart';
// Gunakan titik-titik (Relative Import) untuk memastikan file terbaca
import '../../data/repositories/job_repository.dart';
import '../../data/models/transaction/job_model.dart';
import 'job_detail_page.dart';

class JobListPage extends StatefulWidget {
  const JobListPage({super.key});

  @override
  _JobListPageState createState() => _JobListPageState();
}

class _JobListPageState extends State<JobListPage> {
  // Inisialisasi Repository
  final JobRepository _repository = JobRepository();
  List<JobModel> _jobs = [];
  int _currentLimit = 10;
  String _searchQuery = "";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final data = await _repository.getJobs(
        limit: _currentLimit,
        searchQuery: _searchQuery,
      );

      if (mounted) {
        setState(() {
          _jobs = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pusat Karir Papua"),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Cari lowongan...",
                prefixIcon: const Icon(Icons.search),
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                _searchQuery = value;
                _loadJobs();
              },
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Filter Limit
          ListTile(
            title: const Text("Tampilkan jumlah data:"),
            trailing: DropdownButton<int>(
              value: _currentLimit,
              items: [10, 25, 50].map((int val) {
                return DropdownMenuItem<int>(
                  value: val,
                  child: Text(val.toString()),
                );
              }).toList(),
              onChanged: (val) {
                setState(() {
                  _currentLimit = val!;
                  _loadJobs();
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _jobs.length,
                    itemBuilder: (context, index) {
                      final job = _jobs[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text(job.title),
                          subtitle: Text(job.location),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => JobDetailPage(job: job),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
